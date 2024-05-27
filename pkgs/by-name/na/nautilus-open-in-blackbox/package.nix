{ python3, fetchFromGitHub, gnome, stdenv, lib }:
stdenv.mkDerivation rec {
  pname = "nautilus-open-in-blackbox";
  version = "0.1.1";

  src = fetchFromGitHub {
      owner = "ppvan";
      repo = "nautilus-open-in-blackbox";
      rev = "refs/tags/${version}";
      hash = "sha256-5rvh3qNalpjamcBVQrnAW6GxhwPPlRxP5h045YDqvrM=";
  };

  # The Orignal Source code tries to execute `/usr/bin/blackbox` which is not valid in NixOS
  # This patch replaces the call with `blackbox`
  patches = [ ./paths.patch ];

  buildInputs = [
    gnome.nautilus-python
    python3.pkgs.pygobject3
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 ./nautilus-open-in-blackbox.py -t $out/share/nautilus-python/extensions
    runHook postInstall
  '';

  meta = with lib; {
    description = "Extension for nautilus, which adds an context-entry for opening in blackbox";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ blankparticle ];
    homepage = "https://github.com/ppvan/nautilus-open-in-blackbox";
    platforms = platforms.linux;
  };
}
