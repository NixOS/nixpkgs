{
  stdenvNoCC,
  subversion,
  sshSupport ? true,
  openssh ? null,
  expect,
}:
{
  username,
  password,
  url,
  rev ? "HEAD",
  sha256 ? "",
}:

stdenvNoCC.mkDerivation {
  name = "svn-export-ssh";
  builder = ./builder.sh;
  nativeBuildInputs = [
    subversion
    expect
  ];

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  sshSubversion = ./sshsubversion.exp;

  inherit
    username
    password
    url
    rev
    sshSupport
    openssh
    ;
}
