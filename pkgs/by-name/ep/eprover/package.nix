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

  preConfigure = ''
    sed -e 's/ *CC *= *gcc$//' -i Makefile.vars
  '';

  configureFlags = [
    "--exec-prefix=$(out)"
    "--man-prefix=$(out)/share/man"
  ]
  ++ lib.optionals enableHO [
    "--enable-ho"
  ];

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
