{
  lib,
  buildNpmPackage,
  fetchurl,
  nodejs_20,
}:

buildNpmPackage rec {
  pname = "appium";
  version = "3.3.0";
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://registry.npmjs.org/appium/-/appium-${version}.tgz";
    hash = "sha256-0Nk4ipx3e1EfPi9JHXL6h8QtVXK0JF7RThHNi6KjlVw=";
  };

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  nodejs = nodejs_20;

  dontNpmBuild = true;
  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-MwXXtJZ2KE5twNYIXN0DW6eMV6EQ7L8Gy0yxdyBKOaA=";

  meta = with lib; {
    description = "Cross-platform automation framework for native, hybrid, and mobile web apps";
    longDescription = ''
      Appium is an open-source project and ecosystem of related software,
      designed to facilitate UI automation of many app platforms, including
      mobile (iOS, Android, Tizen), browser (Chrome, Firefox, Safari),
      desktop (macOS, Windows), TV (Roku, tvOS, Android TV, Samsung),
      and more.
    '';

    homepage = "https://appium.io";
    changelog = "https://github.com/appium/appium/releases/tag/appium%40${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ tom-xs ];
    mainProgram = "appium";
    platforms = platforms.all;
  };
}
