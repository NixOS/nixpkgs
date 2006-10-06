<?xml version="1.0"?>

<xsl:stylesheet
  version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:str="http://exslt.org/strings"
  extension-element-prefixes="str">

  <xsl:output method="xml"/>
  
  <xsl:template match="function|command|literal|varname|filename|option|quote">`<xsl:apply-templates/>'</xsl:template>
  
  <xsl:template match="token"><xsl:text>    </xsl:text><xsl:apply-templates /><xsl:text>
</xsl:text></xsl:template>

  <xsl:template match="screen|programlisting">
    <screen><xsl:apply-templates select="str:split(., '&#xA;')" /></screen>
  </xsl:template>

  <xsl:template match="section[following::section]">
    <section>
      <xsl:apply-templates />
      <screen><xsl:text>
      </xsl:text></screen>        
    </section>
  </xsl:template>

  <xsl:template match="*">
    <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
      <xsl:copy-of select="namespace::*" />
      <xsl:for-each select="@*">
	<xsl:attribute name="{name(.)}" namespace="{namespace-uri(.)}">
	  <xsl:value-of select="."/>
	</xsl:attribute>
      </xsl:for-each>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="text()">
    <xsl:value-of select="translate(., '‘’“”—', concat(&quot;`'&quot;, '&quot;&quot;-'))" />
  </xsl:template>
  
</xsl:stylesheet>
