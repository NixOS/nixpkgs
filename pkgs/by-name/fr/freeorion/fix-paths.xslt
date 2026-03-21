<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" omit-xml-declaration="no" indent="yes" />

  <xsl:template match='node() | @*'>
    <xsl:copy>
      <xsl:apply-templates select='node() | @*'/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match='//text()[starts-with(., "@nixStore@")]'>
    <xsl:value-of select='concat("@out@", substring-after(substring-after(., "@nixStore@"), "/"))'/>
  </xsl:template>
</xsl:stylesheet>
