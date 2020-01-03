addXMLCatalogs () {
    local d i
    # ‘xml/dtd’ and ‘xml/xsl’ are deprecated. Catalogs should be
    # installed underneath ‘share/xml’.
    for d in $1/share/xml $1/xml/dtd $1/xml/xsl; do
        if [ -d $d ]; then
            for i in $(find $d -name catalog.xml); do
                XML_CATALOG_FILES+=" $i"
            done
        fi
    done
}

if [ -z "${libxmlHookDone-}" ]; then
    libxmlHookDone=1

    # Set up XML_CATALOG_FILES.  An empty initial value prevents
    # xmllint and xsltproc from looking in /etc/xml/catalog.
    export XML_CATALOG_FILES=''
    if [ -z "$XML_CATALOG_FILES" ]; then XML_CATALOG_FILES=" "; fi
    addEnvHooks "$hostOffset" addXMLCatalogs
fi
