{ stdenv, fetchgit }:
stdenv.mkDerivation rec {
  name = "ecm-tools";
  version = "master";

  src = fetchgit {
    url = "https://github.com/alucryd/ecm-tools";
    rev = "55365b02f237f079334f207133dd85b45270ecd9";
    sha256 = "1arbwnwggkc7ssf0cwwq97k13h7xf2ryjxvf8y028bxaq4xxfchg";
    fetchSubmodules = true;
  };

  preInstall = ''
    mkdir -p "$out/bin"
    substituteInPlace Makefile --replace "$(DESTDIR)/usr/bin" "$out/bin"
  '';
  
  meta = {
    description = "Error Code Modeler";
    longDescription = ''
      Error Code Modeler
      Fork of ECM primarily to host the code because upstream seems dead, 
      with a minor change to how binaries are called to avoid conflicts with 
      Sage Mathematics' ECM.
    '';
  
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.m3tti ];
  };
}
