<?xml version="1.0"?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    version="1.0">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/xhtml/chunkfast.xsl"/>

  <!-- Allow to manually set language in snippet -->
  <xsl:template match="d:programlisting" mode="class.value">
    <xsl:value-of select="concat('programlisting ', @role)"/>
  </xsl:template>

  <xsl:template match="d:screen" mode="class.value">
    <xsl:value-of select="concat('screen ', @role)"/>
  </xsl:template>

  <!-- Add highlight and init scripts -->
  <xsl:param name="html.script" select="'highlight/highlight.pack.js highlight/init.js'"/>

</xsl:stylesheet>
