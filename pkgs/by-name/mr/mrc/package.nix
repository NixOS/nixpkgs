{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libmcfp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mrc";
  version = "1.3.13";

  src = fetchFromGitHub {
    owner = "mhekkel";
    repo = "mrc";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-ib1UpkVZ28JwSUDwU5Hy9R28z7zP/YWogoPBkQ9qRRg=";
  };

  postPatch = ''
    sed -i 's/\(find_package([^ ]*\) [^ )]* QUIET)/\1)/g' CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [ libmcfp ];

  meta = {
    homepage = "https://github.com/mhekkel/mrc";
    description = "Compiler that enables embedding resources directly into executable files";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
})
