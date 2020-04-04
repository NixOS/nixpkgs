{
  stdenv,
  mkDerivation,
  extra-cmake-modules,
  symlinkJoin,
  kwallet,
  signond
}:

mkDerivation rec {

  name = "signon-kwallet-extension";

  preConfigure = ''
    # mock signond plugins dir
    substituteInPlace cmake/modules/FindSignOnExtension.cmake --replace \
      'set(SIGNONEXTENSION_PLUGINDIR ''${_pkgconfig_invoke_result})' \
      'set(SIGNONEXTENSION_PLUGINDIR lib/signon/extensions)'
  '';

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  buildInputs = [
    kwallet
    signond
  ];

  extension = symlinkJoin {
    name = "kwallet-extension";
    paths = [ signond ];
  };

  meta = with stdenv.lib; {
    description = "KWallet integration for signon framework";
    homepage = https://github.com/KDE/signon-kwallet-extension;
    platforms = platforms.linux;

    license = with licenses; [
      gpl2
    ];

    maintainers = [ maintainers.konstantsky ];
  };

}
