{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "ryzen-monitor-ng";
  version = "0-unstable-2026-03-28";

  # Upstream has not updated ryzen_smu header version
  # This fork corrects ryzen_smu header version and
  # adds support for Matisse AMD CPUs.
  src = fetchFromGitHub {
    owner = "plasmin";
    repo = "ryzen_monitor_ng";
    rev = "d62a4304b2f1727de3970b81d81875133b5f8a68";
    hash = "sha256-irX+Y3H16mNVOfh7Hi8jZ0+DbG7un7MvKaMqp+isjoo=";
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

  meta = {
    description = "Access Ryzen SMU information exposed by the ryzen_smu driver";
    homepage = "https://github.com/plasmin/ryzen_monitor_ng";
    changelog = "https://github.com/plasmin/ryzen_monitor_ng/blob/master/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ phdyellow ];
    mainProgram = "ryzen_monitor";
  };
}
