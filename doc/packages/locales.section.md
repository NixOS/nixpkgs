# Locales {#locales}

To allow simultaneous use of packages linked against different versions of `glibc` with different locale archive formats, Nixpkgs patches `glibc` to rely on the `LOCALE_ARCHIVE` environment variable.

On non-NixOS distributions, this variable is obviously not set. This can cause regressions in language support or even crashes in some Nixpkgs-provided programs. The simplest way to mitigate this problem is exporting the `LOCALE_ARCHIVE` variable pointing to `${glibcLocales}/lib/locale/locale-archive`. The drawback (and the reason this is not the default) is the relatively large (a hundred MiB) size of the full set of locales. It is possible to build a custom set of locales by overriding parameters `allLocales` and `locales` of the package.
