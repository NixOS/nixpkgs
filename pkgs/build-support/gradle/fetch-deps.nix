{ mitm-cache
, lib
}:

{ data, pname ? throw "Please pass pname to fetchDeps", name ? "${pname}-deps", ... } @ attrs:

let
  data' = builtins.removeAttrs
    (if builtins.isPath data then lib.importJSON data else data)
    [ "!comment" "!version" ];

  # replace base#name/ver with base/name/ver/name-ver
  decompressNameVer = prefix: let
    splitHash = lib.splitString "#" (builtins.concatStringsSep "/" prefix);
    nameVer = builtins.match "(.*/)?(.*)/(.*)" (lib.last splitHash);
    init = toString (builtins.head nameVer);
    name = builtins.elemAt nameVer 1;
    ver = builtins.elemAt nameVer 2;
  in
    if builtins.length splitHash == 1 then builtins.head splitHash
    else builtins.concatStringsSep "/${name}/${ver}/" (lib.init splitHash ++ [ "${init}${name}-${ver}" ]);

  # `visit` all elements in attrs and merge into a set
  # attrs will be passed as parent1, parent1 will be passed as parent2
  visitAttrs = parent1: prefix: attrs:
    builtins.foldl'
      (a: b: a // b)
      {}
      (lib.mapAttrsToList (visit parent1 attrs prefix) attrs);

  # convert a compressed deps.json into an uncompressed json used for mitm-cache.fetch
  visit = parent2: parent1: prefix: k: v:
    # groupId being present means this is a metadata xml "leaf" and we shouldn't descend further
    if builtins.isAttrs v && !v?groupId
    then visitAttrs parent1 (prefix ++ [k]) v
    else let
      url = "${decompressNameVer prefix}.${k}";
    in {
      ${url} =
        if builtins.isString v then { hash = v; }
        else {
          text = let
            isSnapshot = lib.hasInfix "-SNAPSHOT" url;
            xmlBase = lib.removeSuffix "/maven-metadata.xml" url;
            fileList = builtins.filter (lib.hasPrefix xmlBase) (builtins.attrNames finalData);
            jarPomFileList = builtins.filter (x: lib.hasSuffix ".jar" x || lib.hasSuffix ".pom" x) fileList;
            inherit (v) groupId;
            splitBase = lib.splitString "/" xmlBase;

            # get extension, version, timestamp for all .jar/.pom file URLs
            jarPomList = map (x: let
              extension = lib.last (lib.splitString "." x);
              subPath = lib.removePrefix "${xmlBase}/" (lib.removeSuffix ".${extension}" x);
              # example snapshot subPath: easybind-2.2.1-20230117.075740-16
              # example non-snapshot subPath: 1.9/commons-codec-1.9
              version =
                if isSnapshot then lib.removePrefix "${artifactId}-" (builtins.head (lib.splitString "/" subPath))
                else builtins.head (lib.splitString "/" subPath);
            in {
              inherit extension version;
              # only used for snapshots
              timestamp = builtins.elemAt (lib.splitString "-" version) 1;
            }) jarPomFileList;
            sortedJarPomList =
              lib.sort
                (a: b: lib.splitVersion a.version < lib.splitVersion b.version)
                jarPomList;

            uniqueVersions' =
              (builtins.map ({ i, x }: x.version)
                (builtins.filter ({ i, x }: i == 0 || (builtins.elemAt sortedJarPomList (i - 1)).version != x.version)
                  (lib.imap0 (i: x: { inherit i x; }) sortedJarPomList)));
            latestVer = v.latest or (lib.last uniqueVersions');
            # The very latest version isn't necessarily used by Gradle, so it may not be present in the MITM data.
            # In order to generate better metadata xml, if the latest version is known but wasn't fetched by Gradle,
            # add it anyway.
            uniqueVersions =
              if builtins.elem latestVer uniqueVersions' then uniqueVersions'
              else uniqueVersions' ++ [ latestVer ];

            # example snapshot base: https://oss.sonatype.org/content/groups/public/com/tobiasdiez/easybind/2.2.1-SNAPSHOT
            # example non-snapshot base: https://repo.maven.apache.org/maven2/commons-codec/commons-codec
            artifactId = builtins.elemAt splitBase (builtins.length splitBase - (if isSnapshot then 2 else 1));
            lastUpdated =
              if isSnapshot then builtins.replaceStrings ["."] [""] snapshotTs
              # we don't have the timestamp, but it's fine to include a fake timestamp.
              # if this ever becomes a problem, it's trivial to extend compress-deps-json.py
              # to include the lastUpdated timestamp in the URL
              else "20240101123456";

            # the following are only used for snapshots
            snapshotVer = lib.last splitBase;
            snapshotTsAndNum = lib.splitString "-" latestVer;
            snapshotTs = builtins.elemAt snapshotTsAndNum 1;
            snapshotNum = lib.last snapshotTsAndNum;
            indent = x: s: builtins.concatStringsSep "\n" (map (s: x + s) (lib.splitString "\n" s));
            containsSpecialXmlChars = s: builtins.match ''.*[<>"'&].*'' s != null;

          in
            # make sure all user-provided data is safe
            assert lib.hasInfix "${builtins.replaceStrings ["."] ["/"] groupId}/${artifactId}" url;
            assert !containsSpecialXmlChars groupId;
            assert !containsSpecialXmlChars latestVer;
            if isSnapshot then ''
            <?xml version="1.0" encoding="UTF-8"?>
            <metadata modelVersion="1.1.0">
              <groupId>${groupId}</groupId>
              <artifactId>${artifactId}</artifactId>
              <version>${snapshotVer}</version>
              <versioning>
                <snapshot>
                  <timestamp>${snapshotTs}</timestamp>
                  <buildNumber>${snapshotNum}</buildNumber>
                </snapshot>
                <lastUpdated>${lastUpdated}</lastUpdated>
                <snapshotVersions>
            ${builtins.concatStringsSep "\n" (map (x: indent "      " ''
                  <snapshotVersion>
                    <extension>${x.extension}</extension>
                    <value>${x.version}</value>
                    <updated>${builtins.replaceStrings ["."] [""] x.timestamp}</updated>
                  </snapshotVersion>'') sortedJarPomList)}
                </snapshotVersions>
              </versioning>
            </metadata>
          '' else ''
            <?xml version="1.0" encoding="UTF-8"?>
            <metadata modelVersion="1.1.0">
              <groupId>${groupId}</groupId>
              <artifactId>${artifactId}</artifactId>
              <versioning>
                <latest>${latestVer}</latest>
                <release>${latestVer}</release>
                <versions>
            ${builtins.concatStringsSep "\n" (map (x: "      <version>${x}</version>") uniqueVersions)}
                </versions>
                <lastUpdated>${lastUpdated}</lastUpdated>
              </versioning>
            </metadata>
          '';
        };
    };

  finalData = visitAttrs {} [] data';
in
  mitm-cache.fetch (builtins.removeAttrs attrs [ "pname" ] // {
    inherit name;
    data = finalData // { "!version" = 1; };
  })
