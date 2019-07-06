<?xml version='1.0'?>
<xsl:stylesheet
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:d="http://docbook.org/ns/docbook"
 version="1.0">
 <xsl:param name="section.autolabel" select="1" />
 <xsl:param name="section.label.includes.component.label" select="1" />
 <xsl:param name="html.stylesheet" select="'style.css overrides.css highlightjs/mono-blue.css'" />
 <xsl:param name="html.script" select="'./highlightjs/highlight.pack.js ./highlightjs/loader.js ./search.js ./elasticlunr.min.js'" />
 <xsl:param name="xref.with.number.and.title" select="1" />
 <xsl:param name="use.id.as.filename" select="1" />
 <xsl:param name="chunker.output.encoding" select="'UTF-8'" />
 <xsl:param name="toc.section.depth" select="99" />
 <xsl:param name="admon.style" select="''" />
 <xsl:param name="callout.graphics.extension" select="'.svg'" />
 <xsl:param name="chunk.toc" select="'toc.xml'" />
<!-- <xsl:param name="qanda.in.toc" select="1" />-->
<xsl:template name="make.toc">
  <xsl:param name="toc-context" select="."/>
  <xsl:param name="toc.title.p" select="true()"/>
  <xsl:param name="nodes" select="/NOT-AN-ELEMENT"/>
  <xsl:variable name="root-nodes" select="/"/>
  
  <xsl:variable name="nodes.plus" select="$root-nodes | d:qandaset"/>
  
  <xsl:variable name="toc.title">
   <xsl:if test="$toc.title.p">
    <xsl:choose>
     <xsl:when test="$make.clean.html != 0">
      <div class="toc-title">
       <xsl:call-template name="gentext">
        <xsl:with-param name="key">TableofContents</xsl:with-param>
       </xsl:call-template>
      </div>
     </xsl:when>
     <xsl:otherwise>
      <p>
       <strong>
        <xsl:call-template name="gentext">
         <xsl:with-param name="key">TableofContents</xsl:with-param>
        </xsl:call-template>
       </strong>
      </p>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:if>
  </xsl:variable>
  
  <xsl:choose>
   <xsl:when test="$manual.toc != ''">
    <xsl:variable name="id">
     <xsl:call-template name="object.id"/>
    </xsl:variable>
    <xsl:variable name="toc" select="document($manual.toc, .)"/>
    <xsl:variable name="tocentry" select="$toc//d:tocentry[@linkend=$id]"/>
    <xsl:if test="$tocentry and $tocentry/*">
     <div class="toc">
      <xsl:copy-of select="$toc.title"/>
      <xsl:element name="{$toc.list.type}" namespace="http://www.w3.org/1999/xhtml">
       <xsl:call-template name="toc.list.attributes">
        <xsl:with-param name="toc-context" select="$toc-context"/>
        <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
        <xsl:with-param name="nodes" select="$root-nodes"/>
       </xsl:call-template>
       <xsl:call-template name="manual-toc">
        <xsl:with-param name="tocentry" select="$tocentry/*[1]"/>
       </xsl:call-template>
      </xsl:element>
     </div>
    </xsl:if>
   </xsl:when>
   <xsl:otherwise>
    <xsl:choose>
     <xsl:when test="$qanda.in.toc != 0">
      <xsl:if test="$nodes.plus">
       <div class="toc">
        <xsl:copy-of select="$toc.title"/>
        <xsl:element name="{$toc.list.type}" namespace="http://www.w3.org/1999/xhtml">
         <xsl:call-template name="toc.list.attributes">
          <xsl:with-param name="toc-context" select="$toc-context"/>
          <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
          <xsl:with-param name="nodes" select="$root-nodes"/>
         </xsl:call-template>
         <xsl:apply-templates select="$nodes.plus" mode="toc">
          <xsl:with-param name="toc-context" select="$toc-context"/>
         </xsl:apply-templates>
        </xsl:element>
       </div>
      </xsl:if>
     </xsl:when>
     <xsl:otherwise>
      <xsl:if test="$root-nodes">
       <div class="toc">
        <xsl:copy-of select="$toc.title"/>
        <xsl:element name="{$toc.list.type}" namespace="http://www.w3.org/1999/xhtml">
         <xsl:call-template name="toc.list.attributes">
          <xsl:with-param name="toc-context" select="$toc-context"/>
          <xsl:with-param name="toc.title.p" select="$toc.title.p"/>
          <xsl:with-param name="nodes" select="$root-nodes"/>
         </xsl:call-template>
         <xsl:apply-templates select="$root-nodes" mode="toc">
          <xsl:with-param name="toc-context" select="$toc-context"/>
         </xsl:apply-templates>
        </xsl:element>
       </div>
      </xsl:if>
     </xsl:otherwise>
    </xsl:choose>
    
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
 
</xsl:stylesheet>
