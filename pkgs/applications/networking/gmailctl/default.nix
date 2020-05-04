{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gmailctl";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${version}";
    sha256 = "08q4yjfbwlldirf3j5db18l8kn6sf288wd364s50jlcx2ka8w50j";
  };

  modSha256 = "1c7dk6l8lkq2j04cp5g97hwkwfmmyn5r0vpr5zpavvalxgjidsf4";

  meta = with stdenv.lib; {
    description = "Declarative configuration for Gmail filters";
    homepage = "https://github.com/mbrt/gmailctl";
    license = licenses.mit;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.unix;
  };
}

