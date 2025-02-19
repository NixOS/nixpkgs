import ./make-test-python.nix (
  { pkgs, ... }:
  let
    nodeName = "machine";
  in
  {
    name = "localectl-locale-list";

    nodes.${nodeName} =
      {
        config,
        pkgs,
        options,
        ...
      }:
      {
        i18n.supportedLocales = options.i18n.supportedLocales.default ++ [ "nb_NO.UTF-8/UTF-8" ];
      };

    testScript = ''
      start_all()

      expected_locale_list = """C.UTF-8
      en_US.UTF-8
      nb_NO.UTF-8
      """
      actual_locale_list = ${nodeName}.succeed("localectl list-locales")

      assert (
          expected_locale_list == actual_locale_list
      ), f"Expected locale list\n{expected_locale_list}\n, but got\n{actual_locale_list}"
    '';
  }
)
