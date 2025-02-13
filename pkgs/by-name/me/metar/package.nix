{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
}:

stdenv.mkDerivation {
  pname = "metar";
  version = "0-unstable-2017-02-17";

  src = fetchFromGitHub {
    owner = "keesL";
    repo = "metar";
    rev = "20e9ca69faea330f6c2493b6829131c24cb55147";
    sha256 = "1fgrlnpasqf1ihh9y6zy6mzzybqx0lxvh7gmv03rjdb55dr42dxj";
  };

  buildInputs = [ curl ];

  meta = with lib; {
    homepage = "https://github.com/keesL/metar";
    description = "Downloads weather reports and optionally decodes them";
    longDescription = ''
      METAR reports are meteorogical weather reports for aviation. Metar is a small
      program which downloads weather reports for user-specified stations and
      optionally decodes them into a human-readable format.

      Currently, metar supports decoding date/time, wind, visibility, cloud layers,
      temperature, air pressure and weather phenomena, such as rain, fog, etc. Also,
      more work in the area of clouds need to be done, as support for Cumulus or
      Cumulunimbus is not yet decoded.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ zalakain ];
    mainProgram = "metar";
  };
}
