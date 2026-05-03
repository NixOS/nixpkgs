<?xml version="1.0"?>

<!--
  This script copies the original system.conf from the dbus
  distribution, but sets paths from $serviceDirectories parameter
  and suid helper from $suidHelper parameter.
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                extension-element-prefixes="str"
                >

  <xsl:output method='xml' encoding="UTF-8" doctype-system="busconfig.dtd" />

  <xsl:param name="serviceDirectories" />
  <xsl:param name="suidHelper" />
  <xsl:param name="apparmor" />

  <xsl:template match="/busconfig">
    <busconfig>
      <xsl:copy-of select="child::node()[name() != 'include' and name() != 'standard_system_servicedirs' and name() != 'servicehelper' and name() != 'servicedir' and name() != 'includedir']" />

      <!-- configure AppArmor -->
      <apparmor mode="{$apparmor}"/>

      <!-- set suid helper -->
      <servicehelper><xsl:value-of select="$suidHelper" /></servicehelper>

      <xsl:for-each select="str:tokenize($serviceDirectories)">
        <servicedir><xsl:value-of select="." />/share/dbus-1/system-services</servicedir>
        <includedir><xsl:value-of select="." />/etc/dbus-1/system.d</includedir>
        <includedir><xsl:value-of select="." />/share/dbus-1/system.d</includedir>
      </xsl:for-each>
    </busconfig>
  </xsl:template>

</xsl:stylesheet>
