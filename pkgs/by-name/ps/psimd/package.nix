{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "psimd";
  version = "0-stable-2020-06-17";

  src = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = "psimd";
    rev = "072586a71b55b7f8c584153d223e95687148a900";
    hash = "sha256-lV+VZi2b4SQlRYrhKx9Dxc6HlDEFz3newvcBjTekupo=";
  };

  nativeBuildInputs = [ cmake ];
  
  meta = {
    description = "Portable 128-bit SIMD intrinsics";
    homepage = "https://github.com/Maratyszcza/psimd";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 tmayoff ];
  };
}
