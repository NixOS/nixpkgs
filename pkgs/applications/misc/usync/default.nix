{ stdenv, fetchFromGitHub, scsh, rsync, unison }:

stdenv.mkDerivation rec {
  pname = "usync";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "ebzzry";
    repo = pname;
    rev = "9c87ea8a707a47c3d7f6ef94d07591c5ab594282";
    sha256 = "1r05gw041fz9dkkb70zd6kqw9dd8dhpv87407qxqg43pd7x47kf4";
  };

  installPhase = ''
    install -m 555 -Dt $out/bin $pname
  '';

  postFixup = ''
    substituteInPlace $out/bin/$pname --replace "/usr/bin/env scsh" "${scsh}/bin/scsh"
    substituteInPlace $out/bin/$pname --replace "(rsync " "(${rsync}/bin/rsync "
    substituteInPlace $out/bin/$pname --replace "(unison " "(${unison}/bin/unison "
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ebzzry/usync;
    description = "A simple site-to-site synchronization tool";
    license = licenses.mit;
    maintainers = [ maintainers.ebzzry ];
    platforms = platforms.unix;
  };

  dontBuild = true;
}
