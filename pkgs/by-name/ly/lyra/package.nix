{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lyra";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "bfgroup";
    repo = "lyra";
    rev = finalAttrs.version;
    sha256 = "sha256-h2IO5cUYY5Xn3nmy2pXmRYqRRWHyOwPCrZgKnJf9gU8=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  postPatch = "sed -i s#/usr#$out#g meson.build";

  postInstall = ''
    mkdir -p $out/include
    cp -R $src/include/* $out/include
  '';

  meta = {
    homepage = "https://github.com/bfgroup/Lyra";
    description = "Simple to use, composable, command line parser for C++ 11 and beyond";
    platforms = lib.platforms.unix;
    license = lib.licenses.boost;
    maintainers = [ ];
  };
})
