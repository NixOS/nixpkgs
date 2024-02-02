{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  buildPackages,
  python3,
  pkg-config,
  libsecret,
  nodejs_18,
}:
buildNpmPackage rec {
  pname = "bitwarden-directory-connector-cli";
  version = "2023.10.0";
  nodejs = nodejs_18;

  src = fetchFromGitHub {
    owner = "bitwarden";
    repo = "directory-connector";
    rev = "v${version}";
    hash = "sha256-PlOtTh+rpTxAv8ajHBDHZuL7yeeLVpbAfKEDPQlejIg=";
  };

  postPatch = ''
    ${lib.getExe buildPackages.jq} 'del(.scripts.preinstall)' package.json > package.json.tmp
    mv -f package.json{.tmp,}
  '';

  npmDepsHash = "sha256-jBAWWY12qeX2EDhUvT3TQpnQvYXRsIilRrXGpVzxYvw=";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  makeCacheWritable = true;
  npmBuildScript = "build:cli:prod";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/libexec/bitwarden-directory-connector
    cp -R {build-cli,node_modules} $out/libexec/bitwarden-directory-connector
    runHook postInstall
  '';

  # needs to be wrapped with nodejs so that it can be executed
  postInstall = ''
    chmod +x $out/libexec/bitwarden-directory-connector/build-cli/bwdc.js
    mkdir -p $out/bin
    ln -s $out/libexec/bitwarden-directory-connector/build-cli/bwdc.js $out/bin/bitwarden-directory-connector-cli
  '';

  buildInputs = [
    libsecret
  ];

  nativeBuildInputs = [
    python3
    pkg-config
  ];

  meta = with lib; {
    description = "LDAP connector for Bitwarden";
    homepage = "https://github.com/bitwarden/directory-connector";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [Silver-Golden];
    platforms = platforms.linux;
    mainProgram = "bitwarden-directory-connector-cli";
  };
}
