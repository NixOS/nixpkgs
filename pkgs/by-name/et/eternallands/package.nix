{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,

  cmake,
  pkg-config,

  installShellFiles,
  makeBinaryWrapper,

  openal,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  SDL2_net,
  libvorbis,
  zlib,
  libGLU,
  libpng,
  libxml2,
  libXrandr,
  openssl,
  nlohmann_json,
  cal3d,

  mesa-demos,
  pciutils,
  zenity,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eternallands";
  baseVersion = "1.9.6.1";
  version = "${finalAttrs.baseVersion}-unstable-2024-07-31";

  src = fetchFromGitHub {
    owner = "raduprv";
    repo = "Eternal-Lands";
    rev = "d38703cb9306bdcba9aa8ede479f5aaaeee0d59d";
    hash = "sha256-+u5y+VLBRO0lSqLl6dkQUz/xvalkK1mk8gH8Ode22VU=";
  };

  data = fetchzip {
    url = "https://github.com/raduprv/Eternal-Lands/releases/download/${finalAttrs.baseVersion}/eternallands-data_${finalAttrs.baseVersion}.zip";
    hash = "sha256-ovSmrdUzUqvEUYLwefg+YJsrP/VF5WSzlf47gHcef+k=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config

    installShellFiles
    makeBinaryWrapper
  ];

  buildInputs = [
    cal3d
    libGLU
    libpng
    libvorbis
    libxml2
    libXrandr
    nlohmann_json
    openal
    openssl
    SDL2
    SDL2_ttf
    SDL2_image
    SDL2_net
    zlib
  ];

  postInstall = ''
    mkdir -p $out/share/eternallands
    cp -r ${finalAttrs.data}/* $out/share/eternallands

    # clean default data_dir to load from working directory by default
    sed -i 's|^#data_dir =.*|#data_dir =|g' $out/share/eternallands/el.ini

    install -Dm644 ../eternal_lands_license.txt -t "$out/share/licenses/eternallands"
    install -Dm644 ../pkgfiles/eternallands.{png,xpm} -t "$out/share/pixmaps"
    install -Dm644 ../pkgfiles/eternallands.desktop -t "$out/share/applications"
    installManPage ../pkgfiles/{eternallands,el.linux.bin}.6

    install -Dm755 ../pkgfiles/eternallands "$out/bin/eternallands"

    # fix eternallands wrapper script
    substituteInPlace $out/bin/eternallands \
        --replace-fail "/usr/games/el.linux.bin" "$out/bin/el.linux.bin" \
        --replace-fail "/usr/share/games/EternalLands/" "$out/share/eternallands/" \
        --replace-fail '[ -x /usr/bin/dpkg ]' "false" \
        --replace-fail '[ ! -r ~/.elc/no.el.ini.check -a -n "$config" ]' "false"
  '';

  postFixup = ''
    wrapProgram $out/bin/eternallands \
      --chdir $out/share/eternallands \
      --prefix PATH : ${
        lib.makeBinPath [
          mesa-demos # for glxinfo
          pciutils
          zenity
        ]
      }
  '';

  meta = {
    homepage = "http://www.eternal-lands.com";
    description = "Free 3D fantasy MMORPG";
    # https://github.com/raduprv/Eternal-Lands/blob/master/eternal_lands_license.txt
    license = lib.licenses.free; # TODO: fix license (probably unfree)
    mainProgram = "eternallands";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
