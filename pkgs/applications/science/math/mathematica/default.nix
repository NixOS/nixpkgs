{
  callPackage,
  requireFile,
  config,
  lib,
  cudaPackages,
  cudaSupport ? config.cudaSupport,
  /*
    If you want an older version or a version with web documentation or different language,
    you can override any of the following attributes:
    my_mathematica = mathematica.override {
      version = "X.Y.Z";
      lang = "??";
      webdoc = true;
    };
    This, however, requires that the version you are requesting is known to nixpkgs
    and is added as an entry in ./versions.nix.
    If it is not, you can manually specify all the necessary information:
    my_mathematica = mathematica.override {
      versionInfo = {
        version = "X.Y.Z";
        lang = "en";
        language = "English";
        # Get this hash via a command similar to this:
        # nix-hash --type sha256 --sri \
        # $(nix store add-path Mathematica_XX.X.X_BNDL_LINUX.sh --name 'Mathematica_XX.X.X_BNDL_LINUX.sh')
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
        installer = "Installer_File_Name.sh";
      };
    };
    versionInfo will take precedence over version, lang, & webdoc.
  */
  lang ? "en",
  webdoc ? false,
  version ? null,
  versionInfo ? null,
  /*
    By default, this nix expression will try to find the installer in the Nix Store
    based on the filename and hash (either found in ./versions.nix or provided by user in versionInfo).
    But you can completely override the src:
    my_mathematica = mathematica.override {
      source = pkgs.fetchurl {
        name = "https://example.com/Mathematica_XX.X.X_BNDL_LINUX.sh";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
      };
    };
  */
  source ? null,
}:

let
  versions = import ./versions.nix;

  matching-versions = lib.sort (v1: v2: lib.versionOlder v2.version v1.version) (
    lib.filter (
      v: v.lang == lang && (version == null || isMatching v.version version) && matchesDoc v
    ) versions
  );

  found-version =
    if matching-versions == [ ] then
      throw (
        "No registered Mathematica version found to match"
        + " version=${toString version} and language=${lang},"
        + " ${if webdoc then "using web documentation" else "and with local documentation"}"
      )
    else
      lib.head matching-versions;

  isMatching =
    v1: v2:
    let
      as = lib.splitVersion v1;
      bs = lib.splitVersion v2;
      n = lib.min (lib.length as) (lib.length bs);
      sublist = l: lib.sublist 0 n l;
    in
    lib.compareLists lib.compare (sublist as) (sublist bs) == 0;

  matchesDoc = v: (builtins.match ".*[0-9]_LIN(UX)?.sh" v.installer != null) == webdoc;

  selected = lib.defaultTo found-version versionInfo;

  defaultSource = requireFile {
    name = selected.installer;
    message = ''
      This nix expression requires that ${selected.installer} is
      already part of the store. Find the file on your Mathematica CD
      and add it to the nix store with nix-store --add-fixed sha256 <FILE>.
    '';
    inherit (selected) hash;
  };
in

callPackage ./generic.nix {
  inherit cudaSupport cudaPackages;
  inherit (selected) version lang;

  src = lib.defaultTo defaultSource source;

  name = (
    "mathematica"
    + lib.optionalString cudaSupport "-cuda"
    + "-${selected.version}"
    + lib.optionalString (lang != "en") "-${lang}"
  );
  meta = with lib; {
    description = "Wolfram Mathematica computational software system";
    homepage = "http://www.wolfram.com/mathematica/";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [
      herberteuler
      rafaelrc
      chewblacka
    ];
    platforms = [ "x86_64-linux" ];
  };
}
