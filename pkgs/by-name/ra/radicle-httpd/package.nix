{
  asciidoctor,
  darwin,
  fetchgit,
  git,
  installShellFiles,
  lib,
  makeWrapper,
  man-db,
  rustPlatform,
  stdenv,
  xdg-utils,
}:
rustPlatform.buildRustPackage rec {
  pname = "radicle-httpd";
  version = "0.18.0";
  env.RADICLE_VERSION = version;

  # You must update the radicle-explorer source hash when changing this.
  src = fetchgit {
    url = "https://seed.radicle.xyz/z4V1sjrXqjvFdnCUbxPFqd5p4DtH5.git";
    rev = "refs/namespaces/z6MkkfM3tPXNPrPevKr3uSiQtHPuwnNhu2yUVjgd2jXVsVz5/refs/tags/v${version}";
    hash = "sha256-VHfiL0BSJsYS8QgMf+LEa6HvYoc+dxawTcwB4d6sTg8=";
    sparseCheckout = [ "radicle-httpd" ];
  };

  sourceRoot = "${src.name}/radicle-httpd";
  cargoHash = "sha256-LmUZCu10RsuA8Lu3FjWcV8MzjX5FxBCV6+4zG0GEN2c=";

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
    makeWrapper
  ];
  nativeCheckInputs = [ git ];
  buildInputs = lib.optionals stdenv.buildPlatform.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  doCheck = stdenv.hostPlatform.isLinux;

  postInstall = ''
    for page in $(find -name '*.adoc'); do
      asciidoctor -d manpage -b manpage $page
      installManPage ''${page::-5}
    done
  '';

  postFixup = ''
    for program in $out/bin/* ;
    do
      wrapProgram "$program" \
        --prefix PATH : "${
          lib.makeBinPath [
            git
            man-db
            xdg-utils
          ]
        }"
    done
  '';

  meta = {
    description = "Radicle JSON HTTP API Daemon";
    longDescription = ''
      A Radicle HTTP daemon exposing a JSON HTTP API that allows someone to browse local
      repositories on a Radicle node via their web browser.
    '';
    homepage = "https://radicle.xyz";
    # cargo.toml says MIT and asl20, LICENSE file says GPL3
    license = with lib.licenses; [
      gpl3Only
      mit
      asl20
    ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      gador
      lorenzleutgeb
    ];
    mainProgram = "radicle-httpd";
  };
}
