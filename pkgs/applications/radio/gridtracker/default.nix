<<<<<<< HEAD
{ lib, stdenv, fetchFromGitLab, nix-update-script, nwjs, wrapGAppsHook }:
=======
{ lib
, stdenv
, fetchFromGitLab
, nix-update-script
, nwjs
}:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "gridtracker";
  version = "1.23.0402";

  src = fetchFromGitLab {
    owner = "gridtracker.org";
    repo = "gridtracker";
    rev = "v${version}";
    sha256 = "sha256-6SQuFN8Fi0fbWCYrQIIeSaXR2haI7uux4txCPKEoJvo=";
  };

<<<<<<< HEAD
  nativeBuildInputs = [ wrapGAppsHook ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    substituteInPlace Makefile \
      --replace '$(DESTDIR)/usr' '$(DESTDIR)/'
    substituteInPlace gridtracker.sh \
      --replace "exec nw" "exec ${nwjs}/bin/nw" \
      --replace "/usr/share/gridtracker" "$out/share/gridtracker"
    substituteInPlace gridtracker.desktop \
      --replace "/usr/share/gridtracker/gridview.png" "$out/share/gridtracker/gridview.png"
  '';

  makeFlags = [ "DESTDIR=$(out)" "NO_DIST_INSTALL=1" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "An amateur radio companion to WSJT-X or JTDX";
    longDescription = ''
      GridTracker listens to traffic from WSJT-X/JTDX, displays it on a map,
      and has a sophisticated alerting and filtering system for finding and
      working interesting stations. It also will upload QSO records to multiple
      logging frameworks including Logbook of the World.
    '';
    homepage = "https://gridtracker.org";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ melling ];
  };
}
