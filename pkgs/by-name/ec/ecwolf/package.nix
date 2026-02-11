{
  stdenv,
  lib,
  fetchFromBitbucket,
  cmake,
  pkg-config,
  makeWrapper,
  zlib,
  bzip2,
  libjpeg,
  SDL2,
  SDL2_net,
  SDL2_mixer,
  gtk3,
  writers,
  python3Packages,
  nix-update,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ecwolf";
  version = "1.4.2";

  src = fetchFromBitbucket {
    owner = "ecwolf";
    repo = "ecwolf";
    tag = finalAttrs.version;
    hash = "sha256-T5K6B2fWMKMLB/662p/YLEv0Od9n0vUakznyoOnr0kI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];
  buildInputs = [
    zlib
    bzip2
    libjpeg
    SDL2
    SDL2_net
    SDL2_mixer
    gtk3
  ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = toString [
      "-framework"
      "AppKit"
    ];
  };

  # ECWolf installs its binary to the games/ directory, but Nix only adds bin/
  # directories to the PATH.
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -R ecwolf.app $out/Applications
    makeWrapper $out/{Applications/ecwolf.app/Contents/MacOS,bin}/ecwolf
  '';

  passthru.updateScript =
    let
      updateScriptPkg =
        writers.writePython3 "ecwolf_update_script"
          {
            libraries = with python3Packages; [
              debian-inspector
              requests
            ];
          }
          ''
            from os import execl
            from sys import argv

            from debian_inspector.debcon import get_paragraphs_data
            from requests import get

            # The debian.drdteam.org repo is a primary source of information. It’s
            # run by Blzut3, the creator and primary developer of ECWolf. It’s also
            # listed on ECWolf’s download page:
            # <https://maniacsvault.net/ecwolf/download.php>.
            url = 'https://debian.drdteam.org/dists/stable/multiverse/binary-amd64/Packages'  # noqa: E501
            response = get(url)
            packages = get_paragraphs_data(response.text)
            for package in packages:
                if package['package'] == 'ecwolf':
                    latest_version = package['version']
                    break
            nix_update_path = argv[1]

            execl(nix_update_path, nix_update_path, '--version', latest_version)
          '';
    in
    [
      updateScriptPkg
      (lib.getExe nix-update)
    ];

  meta = {
    description = "Enhanched SDL-based port of Wolfenstein 3D for various platforms";
    mainProgram = "ecwolf";
    homepage = "https://maniacsvault.net/ecwolf/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      jayman2000
    ];
    platforms = lib.platforms.all;
  };
})
