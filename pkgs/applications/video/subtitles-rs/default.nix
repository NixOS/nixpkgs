{ stdenv, fetchFromGitHub, rustPlatform, makeWrapper }:

rustPlatform.buildRustPackage rec {
  name = "subtitles-rs";
  version = "20180611";

  src = fetchFromGitHub {
    owner = "emk";
    repo = "subtitles-rs";
    rev = "83d8a77a095f763e967372aaa00ba5728842eb34";
    sha256 = "15gba9wdw2lprf00x7wvl7pwjg3sh50yvync0waf9b4945zw3b47";
  };

  cargoSha256 = "1851zf4pyi2mj4kq3w16abqi9izr6q9vznf4ap4mnfhaaplbc4x0";

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Tools and libraries for manipulating subtitles";
    homepage = https://github.com/emk/subtitles-rs;
    license = licenses.cc0;
    maintainers = [ maintainers.teto ];
  };
}
