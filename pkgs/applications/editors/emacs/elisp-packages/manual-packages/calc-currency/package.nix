{
  lib,
  melpaBuild,
  fetchFromGitHub,
  fetchpatch,
  unstableGitUpdater,
  f,
}:
melpaBuild {
  pname = "calc-currency";
  version = "0-unstable-2024-12-07";
  src = fetchFromGitHub {
    owner = "jws85";
    repo = "calc-currency";
    rev = "7021d892ef38b01b875082aba4bae2517ce47ae6";
    hash = "sha256-6P7oLlYYe/TS8whaS1FKqV6QMEQIDB3dN1GSpxUElXg=";
  };

  packageRequires = [
    f
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/jws85/calc-currency/pull/5.patch";
      hash = "sha256-gyn696O3DoGDjmg65Ogq+6HKnfesAVqKasRV8SfFFD4=";
    })
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/jws85/calc-currency";
    description = "Add currency units to Emacs Calc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ johnhamelink ];
  };
}
