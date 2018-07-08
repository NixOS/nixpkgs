{ stdenv, rustPlatform , fetchFromGitHub, Security }:
rustPlatform.buildRustPackage rec {
  name = "whitebox_tools-${version}";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "jblindsay";
    repo = "whitebox-tools";
    rev = "6221cdf327be70f0ee4f2053b76bfa01c3f37caa";
    sha256 = "1423ga964mz7qkl88vkcm8qfprsksx04aq4sz9v5ghnmdzzvl89x";
  };

  buildInputs = stdenv.lib.optional stdenv.isDarwin Security;

  cargoSha256 = "1gbgirng21ak0kl3fiyr6lxwzrjd5v79gcrbzf941nb8y8rlvz7k";

  meta = with stdenv.lib; {
    description = "An advanced geospatial data analysis platform";
    homepage = http://www.uoguelph.ca/~hydrogeo/WhiteboxTools/index.html;
    license = licenses.mit;
    maintainers = [ maintainers.mpickering ];
    platforms = platforms.all;
  };
}
