{ bash
, buildGoModule
, common-updater-scripts
, coreutils
, curl
, fetchurl
, git
, gzip
, jq
, lib
, makeWrapper
, nix
, openssh
, pam
, pamSupport ? true
, sqliteSupport ? true
, stdenv
, writeShellApplication
}:

buildGoModule rec {
  pname = "forgejo";
  version = "1.18.3-1";

  src = fetchurl {
    name = "${pname}-src-${version}.tar.gz";
    # see https://codeberg.org/forgejo/forgejo/releases
    url = "https://codeberg.org/attachments/3fdf0967-d3f4-4488-a2bf-276c4a64d97c";
    hash = "sha256-H69qKdmz5qHJ353UZYztUlStpj/RyE6LA8cDaRnVYAQ=";
  };

  vendorHash = null;

  subPackages = [ "." ];

  outputs = [ "out" "data" ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = lib.optional pamSupport pam;

  patches = [
    ./../gitea/static-root-path.patch
  ];

  postPatch = ''
    substituteInPlace modules/setting/setting.go --subst-var data
  '';

  tags = lib.optional pamSupport "pam"
    ++ lib.optionals sqliteSupport [ "sqlite" "sqlite_unlock_notify" ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X 'main.Tags=${lib.concatStringsSep " " tags}'"
  ];

  postInstall = ''
    mkdir $data
    cp -R ./{public,templates,options} $data
    mkdir -p $out
    cp -R ./options/locale $out/locale
    wrapProgram $out/bin/gitea \
      --prefix PATH : ${lib.makeBinPath [ bash git gzip openssh ]}
  '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-forgejo";
    runtimeInputs = [
      common-updater-scripts
      coreutils
      curl
      jq
      nix
    ];
    text = ''
      releases=$(curl "https://codeberg.org/api/v1/repos/forgejo/forgejo/releases?draft=false&pre-release=false&limit=1" \
        --silent \
        --header "accept: application/json")

      stable=$(jq '.[0]
        | .tag_name[1:] as $version
        | ("forgejo-src-\($version).tar.gz") as $filename
        | { $version, html_url } + (.assets | map(select(.name | startswith($filename)) | {(.name | split(".") | last): .browser_download_url}) | add)' \
        <<< "$releases")

      archive_url=$(jq -r .gz <<< "$stable")
      checksum_url=$(jq -r .sha256 <<< "$stable")
      release_url=$(jq -r .html_url <<< "$stable")
      version=$(jq -r .version <<< "$stable")

      if [[ "${version}" = "$version" ]]; then
        echo "No new version found (already at $version)"
        exit 0
      fi

      echo "Release: $release_url"

      sha256=$(curl "$checksum_url" --silent | cut --delimiter " " --fields 1)
      sri_hash=$(nix hash to-sri --type sha256 "$sha256")

      update-source-version "${pname}" "$version" "$sri_hash" "$archive_url"
    '';
  });

  meta = with lib; {
    description = "A self-hosted lightweight software forge";
    homepage = "https://forgejo.org";
    changelog = "https://codeberg.org/forgejo/forgejo/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ indeednotjames urandom ];
    broken = stdenv.isDarwin;
    mainProgram = "gitea";
  };
}
