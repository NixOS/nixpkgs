addSGMLCatalogs () {
      if test -d $1/sgml/dtd; then
          for i in $(find $1/sgml/dtd -name docbook.cat); do
              export SGML_CATALOG_FILES="${SGML_CATALOG_FILES:+:}$i"
          done
      fi
}

if test -z "${sgmlHookDone-}"; then
    sgmlHookDone=1

    # Set http_proxy and ftp_proxy to a invalid host to prevent
    # xmllint and xsltproc from trying to download DTDs from the
    # network even when --nonet is not given.  That would be impure.
    # (Note that .invalid is a reserved domain guaranteed not to
    # work.)
    export http_proxy=http://nodtd.invalid/
    export ftp_proxy=http://nodtd.invalid/

    export SGML_CATALOG_FILES
    addEnvHooks "$targetOffset" addSGMLCatalogs
fi
