{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  alsa-lib,
<<<<<<< HEAD
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sof-tools";
  version = "2.14";
=======
}:

stdenv.mkDerivation rec {
  pname = "sof-tools";
  version = "2.10";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "thesofproject";
    repo = "sof";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y3byJmoANVeilJpO82aljBZas/6u6VqfynYl0csW1as=";
  };

  postPatch = ''
    patchShebangs ../scripts/gen-uuid-reg.py
  '';

  nativeBuildInputs = [
    cmake
    python3
  ];
  buildInputs = [ alsa-lib ];
  sourceRoot = "${finalAttrs.src.name}/tools";

  meta = {
    description = "Tools to develop, test and debug SoF (Sund Open Firmware)";
    homepage = "https://thesofproject.github.io";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.johnazoidberg ];
    mainProgram = "sof-ctl";
  };
})
=======
    rev = "v${version}";
    hash = "sha256-VmP0z3q1P8LqQ+ELZGkI7lEXGiMYdAPvS8Lbwv6dUyk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ alsa-lib ];
  sourceRoot = "${src.name}/tools";

  meta = with lib; {
    description = "Tools to develop, test and debug SoF (Sund Open Firmware)";
    homepage = "https://thesofproject.github.io";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.johnazoidberg ];
    mainProgram = "sof-ctl";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
