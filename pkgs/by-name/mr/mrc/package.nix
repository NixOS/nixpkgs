{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libmcfp
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mrc";
  # 1.3.11 & later does not build, see https://github.com/mhekkel/mrc/issues/16
  version = "1.3.10";

  src = fetchFromGitHub {
    owner = "mhekkel";
    repo = "mrc";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-8uYoQ7VF9mUSYVXcpmmwAn0PAEn1+Es2k7h7Hlg6+Y4=";
  };

  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "1.2.4 QUIET" ""
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libmcfp ];

  meta = {
    homepage = "https://github.com/mhekkel/mrc";
    description = "Maartens Resource Compiler";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
  };
})
