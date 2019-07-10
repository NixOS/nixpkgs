{ stdenv, buildGoModule, fetchurl }:

buildGoModule rec {
  name = "cordless-${version}";
  version = "2019-06-13";

  src = fetchurl {
    url = "https://github.com/Bios-Marcel/cordless/archive/${version}.tar.gz";
    sha256 = "ef9c4db21b7c75a5263281ed783c905b47e752f8b596575e0a41cd6e7d450566";
  };

  doCheck = true;

  modSha256 = "08a1dg4d7fjdy8w3sbri3ik8k7c1snpa0rzwinal6inzmdyancys";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A third party Discord client";
    longDescription = ''
      Cordless is a third party Discord client that runs on the
      commandline and aims to have a low memory footprint and
      bandwidth consumption.
    '';
    homepage = https://www.github.com/Bios-Marcel/cordless;
    license = licenses.bsd3;
    maintainers = [ "Marcel Schramm <marceloschr@googlemail.com>" ];
    platforms = platforms.linux;
  };
}