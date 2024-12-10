{ lib, fetchFromGitHub, python3Packages, gobject-introspection, wrapGAppsNoGuiHook }:

python3Packages.buildPythonPackage rec {
  pname = "open-fprintd";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "uunicorn";
    repo = pname;
    rev = version;
    hash = "sha256-uVFuwtsmR/9epoqot3lJ/5v5OuJjuRjL7FJF7oXNDzU=";
  };

  nativeBuildInputs = [ wrapGAppsNoGuiHook gobject-introspection ];

  propagatedBuildInputs = with python3Packages; [ dbus-python pygobject3 ];

  checkInputs = with python3Packages; [ dbus-python ];

  postInstall = ''
    install -D -m 644 debian/open-fprintd.service \
      $out/lib/systemd/system/open-fprintd.service
    install -D -m 644 debian/open-fprintd-resume.service \
      $out/lib/systemd/system/open-fprintd-resume.service
    install -D -m 644 debian/open-fprintd-suspend.service \
      $out/lib/systemd/system/open-fprintd-suspend.service
    substituteInPlace $out/lib/systemd/system/open-fprintd.service \
      --replace /usr/lib/open-fprintd "$out/lib/open-fprintd"
    substituteInPlace $out/lib/systemd/system/open-fprintd-resume.service \
      --replace /usr/lib/open-fprintd "$out/lib/open-fprintd"
    substituteInPlace $out/lib/systemd/system/open-fprintd-suspend.service \
      --replace /usr/lib/open-fprintd "$out/lib/open-fprintd"
  '';

  dontWrapGApps = true;
  makeWrapperArgs = [ "\${gappsWrapperArgs[@]}" ];

  postFixup = ''
    wrapPythonProgramsIn "$out/lib/open-fprintd" "$out $pythonPath"
  '';

  meta = with lib; {
    description =
      "Fprintd replacement which allows you to have your own backend as a standalone service";
    homepage = "https://github.com/uunicorn/open-fprintd";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
