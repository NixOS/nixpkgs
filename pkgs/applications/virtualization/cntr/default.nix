{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cntr";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "cntr";
    rev = version;
    sha256 = "0dhfz7aj3cqi974ybf0axchih40rzrs9m8bxhwz1hgig57aisfc0";
  };

  cargoSha256 = "0xkwza9fx61pvlsm0s3dxc9i09mqp6c9df8w63fyiq7174vjxryx";

  meta = with stdenv.lib; {
    description = "A container debugging tool based on FUSE";
    homepage = https://github.com/Mic92/cntr;
    license = licenses.mit;
    # aarch64 support will be fixed soon
    platforms = [ "x86_64-linux" ];
    maintainers = [ maintainers.mic92 ];
  };
}
