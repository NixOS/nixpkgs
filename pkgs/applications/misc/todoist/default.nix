{ stdenv, buildGoModule, fetchFromGitHub, Security }:

buildGoModule rec {
  pname = "todoist";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "sachaos";
    repo = "todoist";
    rev = "v${version}";
    sha256 = "0d3c621jaqxd6i58xm6nvi0avrh5mk23r169i95bn73igzw62w33";
  };

  modSha256 = "1nnp5ijz4n34gc97rar4wlvlbx21ndpjyb2mc6gxdk1wzx3mgswp";

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ Security ];

  meta = with stdenv.lib; {
    homepage = https://github.com/sachaos/todoist;
    description = "Todoist CLI Client";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
