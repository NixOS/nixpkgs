{ pkgs, ... }:
{
  name = "bulwark";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      Cameo007
    ];
  };

  nodes.machine = {
    services.bulwark = {
      enable = true;
      allow_custom_jmap_endpoint = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("bulwark")
    machine.wait_for_open_port(3000)

    expected_config = '{"appName":"Webmail","jmapServerUrl":"","oauthEnabled":false,"oauthOnly":false,"oauthClientId":"","oauthIssuerUrl":"","rememberMeEnabled":false,"settingsSyncEnabled":false,"stalwartFeaturesEnabled":true,"devMode":false,"faviconUrl":"/branding/Bulwark_Favicon.svg","appLogoLightUrl":"/branding/Bulwark_Logo_Color.svg","appLogoDarkUrl":"/branding/Bulwark_Logo_White.svg","loginLogoLightUrl":"/branding/Bulwark_Logo_Color.svg","loginLogoDarkUrl":"/branding/Bulwark_Logo_White.svg","loginCompanyName":"","loginImprintUrl":"","loginPrivacyPolicyUrl":"","loginWebsiteUrl":"","demoMode":false,"allowCustomJmapEndpoint":true,"autoSsoEnabled":false,"embeddedMode":false,"parentOrigin":""}'

    config = machine.succeed("curl -f http://localhost:3000/api/config")
    assert config == expected_config, "The fetched config does not match"

    expected_admin_policy = '{"restrictions":{},"features":{"pluginsEnabled":false,"pluginsUploadEnabled":true,"requirePluginApproval":true,"themesEnabled":true,"sidebarAppsEnabled":true,"userThemesEnabled":true,"settingsExportEnabled":true,"customKeywordsEnabled":true,"templatesEnabled":true,"calendarTasksEnabled":true,"smimeEnabled":true,"externalContentEnabled":true,"debugModeEnabled":true,"folderIconsEnabled":true,"hoverActionsConfigEnabled":true,"filesEnabled":true},"defaults":{},"themePolicy":{"disabledBuiltinThemes":[],"disabledThemes":[],"defaultThemeId":null},"forceEnabledPlugins":[],"approvedPlugins":[],"forceEnabledThemes":[]}'

    admin_policy = machine.succeed("curl -f http://localhost:3000/api/admin/policy")
    assert admin_policy == expected_admin_policy, "The fetched admin policy does not match"
  '';
}
