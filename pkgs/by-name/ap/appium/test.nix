{ runCommand, appium, gnugrep, nodePackages, yq-go }:
let
  inherit (appium) pname version;
  inherit (nodePackages)
    appium-chromium-driver
    appium-espresso-driver
    appium-geckodriver
    appium-mac2-driver
    appium-safari-driver
    appium-uiautomator2-driver
    appium-xcuitest-driver;
  appium-with-drivers = appium.override {
    drivers = [
      appium-chromium-driver
      appium-espresso-driver
      appium-geckodriver
      appium-mac2-driver
      appium-safari-driver
      appium-uiautomator2-driver
      appium-xcuitest-driver
    ];
  };
in
runCommand "${pname}-tests" { }
''
${appium-with-drivers}/bin/appium driver list --json > $out
echo Checking for chromium driver
${yq-go}/bin/yq '.chromium.installed' $out | grep true
${yq-go}/bin/yq '.chromium.version' $out | grep '${appium-chromium-driver.version}'

echo Checking for espresso driver
${yq-go}/bin/yq '.espresso.installed' $out | grep true
${yq-go}/bin/yq '.espresso.version' $out | grep '${appium-espresso-driver.version}'

echo Checking for geckodriver driver
${yq-go}/bin/yq '.gecko.installed' $out | grep true
${yq-go}/bin/yq '.gecko.version' $out | grep '${appium-geckodriver.version}'

echo Checking for mac2 driver
${yq-go}/bin/yq '.mac2.installed' $out | grep true
${yq-go}/bin/yq '.mac2.version' $out | grep '${appium-mac2-driver.version}'

echo Checking for safari driver
${yq-go}/bin/yq '.safari.installed' $out | grep true
${yq-go}/bin/yq '.safari.version' $out | grep '${appium-safari-driver.version}'

echo Checking for uiautomator2 driver
${yq-go}/bin/yq '.uiautomator2.installed' $out | grep true
${yq-go}/bin/yq '.uiautomator2.version' $out | grep '${appium-uiautomator2-driver.version}'

echo Checking for xcuitest driver
${yq-go}/bin/yq '.xcuitest.installed' $out | grep true
${yq-go}/bin/yq '.xcuitest.version' $out | grep '${appium-xcuitest-driver.version}'
''
