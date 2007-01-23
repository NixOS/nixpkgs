<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:str="http://exslt.org/strings"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns="http://docbook.org/ns/docbook"
                extension-element-prefixes="str"
                >

  <xsl:output method='xml' encoding="UTF-8" />

  <xsl:template match="/expr/list">

    <chapter>
      <title>List of Options</title>

      <variablelist>

        <xsl:for-each select="attrs">

          <varlistentry>
             <term>
               <option>
                 <xsl:for-each select="attr[@name = 'name']/list/string">
                   <xsl:value-of select="@value" />
                   <xsl:if test="position() != last()">.</xsl:if> 
                 </xsl:for-each>
               </option>
             </term>

             <listitem><para>
               <xsl:value-of disable-output-escaping="yes"
                             select="attr[@name = 'description']/string/@value" />
             </para></listitem>

          </varlistentry>

        </xsl:for-each>

      </variablelist>

    </chapter>

  </xsl:template>
  
</xsl:stylesheet>
