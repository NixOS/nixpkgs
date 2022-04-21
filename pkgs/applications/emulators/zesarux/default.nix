{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, SDL2
, aalib
, alsa-lib
, libXext
, libXxf86vm
, libcaca
, libpulseaudio
, libsndfile
, ncurses
, openssl
, which
}:

stdenv.mkDerivation rec {
  pname = "zesarux";
  version = "10.0";

  src = fetchFromGitHub {
    owner = "chernandezba";
    repo = pname;
    rev = version;
    hash = "sha256-cxV2dAzGnIzJiCRdq8vN/Cl4AQeJqjmiCAahijIJQ9k=";
  };

  nativeBuildInputs = [
    which
  ];

  buildInputs = [
    SDL2
    aalib
    alsa-lib
    libXxf86vm
    libXext
    libcaca
    libpulseaudio
    libsndfile
    ncurses
    openssl
  ];

  patches = [
    # Patch the shell scripts; remove it when the next version arrives
    (fetchpatch {
      name = "000-fix-shebangs.patch";
      url = "https://github.com/chernandezba/zesarux/commit/4493439b38f565c5be7c36239ecaf0cf80045627.diff";
      sha256 = "sha256-f+21naPcPXdcVvqU8ymlGfl1WkYGOeOBe9B/WFUauTI=";
    })

    # Patch pending upstream release for libcaca-0.99.beta20 support:
    #  https://github.com/chernandezba/zesarux/pull/1
    (fetchpatch {
      name = "libcaca-0.99.beta20.patch";
      url = "https://github.com/chernandezba/zesarux/commit/542786338d00ab6fcdf712bbd6f5e891e8b26c34.diff";
      sha256 = "sha256-UvXvBb9Nzw5HNz0uiv2SV1Oeiw7aVCa0jhEbThDRVec=";
    })
  ];

  postPatch = ''
    cd src
    patchShebangs ./configure *.sh
  '';

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--c-compiler ${stdenv.cc.targetPrefix}cc"
    "--enable-cpustats"
    "--enable-memptr"
    "--enable-sdl2"
    "--enable-ssl"
    "--enable-undoc-scfccf"
    "--enable-visualmem"
  ];

  installPhase = ''
    runHook preInstall

    ./generate_install_sh.sh
    patchShebangs ./install.sh
    ./install.sh

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/chernandezba/zesarux";
    description = " ZX Second-Emulator And Released for UniX";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: Darwin support
