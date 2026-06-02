{
  lib,
  stdenv,
  fetchurl,
  which,
  enableHO ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eprover";
  version = "3.2";

  src = fetchurl {
    url = "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_${finalAttrs.version}/E.tgz";
    hash = "sha256-B0yOX8MGJHY0HOeQ/RWtgATTIta2YnhEvSdoqIML1K4=";
  };

  buildInputs = [ which ];

  patches = [
    ./fix-cross-toolchains.patch
  ];

  configurePlatforms = [ ];

  configureFlags = [
    "--exec-prefix=$(out)"
    "--man-prefix=$(out)/share/man"
  ]
  ++ lib.optionals enableHO [
    "--enable-ho"
  ];

  # need to directly insert into makeFlagsArray as the makefile expects the binary
  # in the AR variable to already be passed the `rcs` flags, which requires us to
  # specify them. As this requires spaces, we need makeFlagsArray, as makeFlags
  # will just make the make script see the `rcs` as a target
  preBuild = ''
    makeFlagsArray+=(CC="${stdenv.cc.targetPrefix}cc" AR="${stdenv.cc.targetPrefix}ar rcs")
  '';

  meta = {
    description = "Automated theorem prover for full first-order logic with equality";
    homepage = "http://www.eprover.org/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      raskin
    ];
    platforms = lib.platforms.all;
  };
})
