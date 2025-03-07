{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  curl,
  openssl,
  fuse,
  libxml2,
  json_c,
  file,
}:

stdenv.mkDerivation rec {
  pname = "hubicfuse";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "TurboGit";
    repo = "hubicfuse";
    rev = "v${version}";
    sha256 = "1x988hfffxgvqxh083pv3lj5031fz03sbgiiwrjpaiywfbhm8ffr";
  };

  patches = [
    # Fix Darwin build
    # https://github.com/TurboGit/hubicfuse/pull/159
    (fetchpatch {
      url = "https://github.com/TurboGit/hubicfuse/commit/b460f40d86bc281a21379158a7534dfb9f283786.patch";
      sha256 = "0nqvcbrgbc5dms8fkz3brlj40yn48p36drabrnc26gvb3hydh5dl";
    })
    # UPstream fix for build failure on -fno-common toolchains
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/TurboGit/hubicfuse/commit/34a6c3e57467b5f7e9befe2171bf4292893c5a18.patch";
      sha256 = "0k1jz2h8sdhmi0srx0adbyrcrm57j4annj84yw6hdrly5hsf7bzc";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    curl
    openssl
    fuse
    libxml2
    json_c
    file
  ];
  postInstall = ''
    install hubic_token $out/bin
    mkdir -p $out/sbin
    ln -sf $out/bin/hubicfuse $out/sbin/mount.hubicfuse
  '';

  meta = with lib; {
    homepage = "https://github.com/TurboGit/hubicfuse";
    description = "FUSE-based filesystem to access hubic cloud storage";
    platforms = platforms.unix;
    license = licenses.mit;
    maintainers = [ maintainers.jpierre03 ];
  };
}
