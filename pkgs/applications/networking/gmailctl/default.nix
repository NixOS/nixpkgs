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

  vendorSha256 = "0qp8n7z3vcsbc6safp7i18i0i3r4hy4nidzwl85i981sg12vcg6b";

  meta = with stdenv.lib; {
    description = "Declarative configuration for Gmail filters";
    homepage = "https://github.com/mbrt/gmailctl";
    license = licenses.mit;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.unix;
  };
}
