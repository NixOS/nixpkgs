{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scrounge-ntfs";
  version = "0.9";

  src = fetchurl {
    url = "http://thewalter.net/stef/software/scrounge/scrounge-ntfs-${finalAttrs.version}.tar.gz";
    hash = "sha256-HYrMIMTRPmgAac/vaZ1jaUFchyAl5B0quxgHH0DHJ84=";
  };

  patches = [
    ./darwin.diff
  ];

  meta = with lib; {
    description = "Data recovery program for NTFS file systems";
    mainProgram = "scrounge-ntfs";
    homepage = "http://thewalter.net/stef/software/scrounge/";
    maintainers = with maintainers; [ d3vil0p3r ];
    platforms = platforms.unix;
    license = licenses.bsd3;
  };
})
