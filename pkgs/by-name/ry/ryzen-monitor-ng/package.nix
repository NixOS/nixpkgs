{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "ryzen-monitor-ng";
  version = "2.0.5-unstable-2023-11-05";

  # Upstream has not updated ryzen_smu header version
  # This fork corrects ryzen_smu header version and
  # adds support for Matisse AMD CPUs.
  src = fetchFromGitHub {
    owner = "plasmin";
    repo = "ryzen_monitor_ng";
    rev = "8b7854791d78de731a45ce7d30dd17983228b7b1";
    hash = "sha256-xdYNtXCbNy3/y5OAHZEi9KgPtwr1LTtLWAZC5DDCfmE=";
    # Upstream repo contains pre-compiled binaries and object files
    # that are out of date.
    # These need to be removed before build stage.
    postFetch = ''
      rm "$out/src/ryzen_monitor"
      make -C "$out" clean
    '';
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Access Ryzen SMU information exposed by the ryzen_smu driver";
    homepage = "https://github.com/plasmin/ryzen_monitor_ng";
    changelog = "https://github.com/plasmin/ryzen_monitor_ng/blob/master/CHANGELOG.md";
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ phdyellow ];
    mainProgram = "ryzen_monitor";
  };
}
