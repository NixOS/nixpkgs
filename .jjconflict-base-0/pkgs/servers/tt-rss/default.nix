{ lib, stdenv, fetchgit }:

stdenv.mkDerivation rec {
  pname = "tt-rss";
  version = "unstable-2023-04-13";

  src = fetchgit {
    url = "https://git.tt-rss.org/fox/tt-rss.git";
    rev = "0578bf802571781a0a7e3debbbec66437a7d28b4";
    hash = "sha256-j6R1QoH8SzUtyI3rGE6rHriboAfApAo/Guw8WbJ7LqU=";
  };

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -ra * $out/

    # see the code of Config::get_version(). you can check that the version in
    # the footer of the preferences pages is not UNKNOWN
    echo "23.04" > $out/version_static.txt

    runHook postInstall
  '';

  meta = with lib; {
    description = "Web-based news feed (RSS/Atom) aggregator";
    license = licenses.gpl2Plus;
    homepage = "https://tt-rss.org";
    maintainers = with maintainers; [ globin zohl ];
    platforms = platforms.all;
  };
}
