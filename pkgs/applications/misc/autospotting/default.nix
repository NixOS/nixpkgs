{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "autospotting-${version}";
  version = "unstable-2018-11-17";
  goPackagePath = "github.com/AutoSpotting/AutoSpotting";

  src = fetchFromGitHub {
    owner = "AutoSpotting";
    repo = "AutoSpotting";
    rev = "122ab8f292a2f718dd85e79ec22acd455122907e";
    sha256 = "0p48lgig9kblxvgq1kggczkn4qdbx6ciq9c8x0179i80vl4jf7v6";
  };

  goDeps = ./deps.nix;

  # patching path where repository used to exist
  postPatch = ''
    sed -i "s+github.com/cristim/autospotting/core+github.com/AutoSpotting/AutoSpotting/core+" autospotting.go
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/AutoSpotting/AutoSpotting;
    description = "Automatically convert your existing AutoScaling groups to up to 90% cheaper spot instances with minimal configuration changes";
    license = licenses.free;
    maintainers = [ maintainers.costrouc ];
    platforms = platforms.unix;
  };

}
