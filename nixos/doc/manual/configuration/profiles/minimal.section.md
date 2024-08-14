# Minimal {#sec-profile-minimal}

This profile defines a small NixOS configuration. It does not contain any
graphical stuff. It's a very short file that enables
[noXlibs](#opt-environment.noXlibs), sets
[](#opt-i18n.supportedLocales) to
only support the user-selected locale,
and [disables packages' documentation](#opt-documentation.enable).
