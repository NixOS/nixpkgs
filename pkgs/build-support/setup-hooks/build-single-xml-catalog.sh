# Creates a single XML catalog that references the catalogs found by
# findXMLCatalogs.
# Useful for situations where only one catalog is expected.
buildSingleXMLCatalog() {
    echo '<?xml version="1.0"?>' > catalog.xml
    echo '<catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">' >> catalog.xml

    catalogs=$(echo $XML_CATALOG_FILES | tr " " "\n")
    for x in $catalogs
    do
        echo '  <nextCatalog catalog="'$x'" />' >> catalog.xml
    done

    echo '</catalog>' >> catalog.xml
}

if [ -z "$buildSingleXMLCatalogHookDone" ]; then
    buildSingleXMLCatalogHookDone=1

    envHooks+=(buildSingleXMLCatalog)
fi
