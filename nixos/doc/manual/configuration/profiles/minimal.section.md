# Minimal {#sec-profile-minimal}

This profile defines a small NixOS configuration. It does not contain any
graphical stuff. It's a very short file that enables
[noXlibs](options.html#opt-environment.noXlibs), sets
[`i18n.supportedLocales`](options.html#opt-i18n.supportedLocales) to
only support the user-selected locale,
[disables packages' documentation](options.html#opt-documentation.enable),
and [disables sound](options.html#opt-sound.enable).
