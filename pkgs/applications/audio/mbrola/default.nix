{ stdenv, lib, fetchFromGitHub }:

let
  voices = fetchFromGitHub {
    owner = "numediart";
    repo = "MBROLA-voices";
    rev = "fe05a0ccef6a941207fd6aaad0b31294a1f93a51";  # using latest commit
    sha256 = "1w0y2xjp9rndwdjagp2wxh656mdm3d6w9cs411g27rjyfy1205a0";
  };
in
stdenv.mkDerivation rec {
  pname = "mbrola";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "numediart";
    repo = "MBROLA";
    rev = version;
    sha256 = "1w86gv6zs2cbr0731n49z8v6xxw0g8b0hzyv2iqb9mqcfh38l8zy";
  };

  # required for cross compilation
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    runHook preInstall
    install -D Bin/mbrola $out/bin/mbrola

    # TODO: package separately because it's very big
    install -d $out/share/mbrola/voices
    cp -R ${voices}/data/* $out/share/mbrola/voices/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Speech synthesizer based on the concatenation of diphones";
    homepage = "https://github.com/numediart/MBROLA";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ davidak ];
    platforms = platforms.linux;
  };
}
