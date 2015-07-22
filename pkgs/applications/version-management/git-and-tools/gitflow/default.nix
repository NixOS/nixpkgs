{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gitflow-${version}";
  version = "1.8.0";

  src = fetchurl {
    url = "https://github.com/petervanderdoes/gitflow/archive/${version}.tar.gz";
    sha256 = "1vxdawx4sinl19g59ifmrdalmr2dl5pkgawyj9z0s5mcildi6fc2";
  };

  preBuild = ''
    makeFlagsArray+=(prefix="$out")
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/petervanderdoes/gitflow;
    description = "Extend git with the Gitflow branching model";
    longDescription = ''
      A set of scripts that provide high-level repository operations
      for managing feature/release/hotfix branches in a Git repository,
      particularly suited to be utilised to follow Vincent Driessen's
      branching model.
    '';
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = with maintainers; [ offline jgeerds ];
  };
}
