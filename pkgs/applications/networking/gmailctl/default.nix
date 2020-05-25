{ stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gmailctl";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${version}";
    sha256 = "0g581gdkib7bj86blpm8skjvbnivmzh9ddikxai9hr5qq231j1pb";
  };

  modSha256 = "0pv3lhzl96ygzh9y01hi9klrrk403ii92imr9yrbimaf7rsvyvjp";

  meta = with stdenv.lib; {
    description = "Declarative configuration for Gmail filters";
    homepage = "https://github.com/mbrt/gmailctl";
    license = licenses.mit;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.unix;
  };
}

