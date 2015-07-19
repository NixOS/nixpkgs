<?xml version="1.0"?>

<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    version="1.0">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl-ns/current/xhtml/chunk.xsl"/>

  <!-- Chunking  -->
  <xsl:param name="onechunk" select="1"/>
  <xsl:param name="suppress.navigation">1</xsl:param>

  <xsl:template match="d:appendix">
    <xsl:call-template name="process-chunk"/>
  </xsl:template>

  <xsl:template name="chunk">
    <xsl:param name="node" select="."/>
    <!-- returns 1 if $node is a chunk -->
    <xsl:choose>
      <xsl:when test="$node/parent::*/processing-instruction('dbhtml')[normalize-space(.) = 'stop-chunking']">0</xsl:when>
      <xsl:when test="not($node/parent::*)">1</xsl:when>
      <xsl:when test="local-name($node)='appendix'">1</xsl:when>
      <xsl:otherwise>0</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Allow to manually set language in snippet -->
  <xsl:template match="d:programlisting" mode="class.value">
    <xsl:value-of select="concat('programlisting ', @role)"/>
  </xsl:template>

  <xsl:template match="d:screen" mode="class.value">
    <xsl:value-of select="concat('screen ', @role)"/>
  </xsl:template>

  <!-- Add highlight and init scripts -->
  <xsl:param name="html.script" select="'highlight.js init.js'"/>

  <xsl:template name="section.heading">
    <xsl:param name="section" select="."/>
    <xsl:param name="level" select="1"/>
    <xsl:param name="allow-anchors" select="1"/>
    <xsl:param name="title"/>
    <xsl:param name="class" select="'title'"/>

    <xsl:variable name="id">
      <xsl:choose>
        <!-- Make sure the subtitle doesn't get the same id as the title -->
        <xsl:when test="self::d:subtitle">
          <xsl:call-template name="object.id">
            <xsl:with-param name="object" select="."/>
          </xsl:call-template>
        </xsl:when>
        <!-- if title is in an *info wrapper, get the grandparent -->
        <xsl:when test="contains(local-name(..), 'info')">
          <xsl:call-template name="object.id">
            <xsl:with-param name="object" select="../.."/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="object.id">
            <xsl:with-param name="object" select=".."/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- HTML H level is one higher than section level -->
    <xsl:variable name="hlevel">
      <xsl:choose>
        <!-- highest valid HTML H level is H6; so anything nested deeper
             than 5 levels down just becomes H6 -->
        <xsl:when test="$level &gt; 5">6</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$level + 1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:element name="h{$hlevel}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
      <xsl:if test="$css.decoration != '0'">
        <xsl:if test="$hlevel&lt;3">
          <xsl:attribute name="style">clear: both</xsl:attribute>
        </xsl:if>
      </xsl:if>
      <xsl:if test="$allow-anchors != 0">
        <xsl:call-template name="anchor">
          <xsl:with-param name="node" select="$section"/>
          <xsl:with-param name="conditional" select="0"/>
        </xsl:call-template>
      </xsl:if>

      <a href="#{$id}">
        <xsl:copy-of select="$title"/>
      </a>
    </xsl:element>
  </xsl:template>

  <xsl:template name="component.title">
    <xsl:param name="node" select="."/>

    <!-- This handles the case where a component (bibliography, for example)
         occurs inside a section; will we need parameters for this? -->

    <!-- This "level" is a section level.  To compute <h> level, add 1. -->
    <xsl:variable name="level">
      <xsl:choose>
        <!-- chapters and other book children should get <h1> -->
        <xsl:when test="$node/parent::d:book">0</xsl:when>
        <xsl:when test="ancestor::d:section">
          <xsl:value-of select="count(ancestor::d:section)+1"/>
        </xsl:when>
        <xsl:when test="ancestor::d:sect5">6</xsl:when>
        <xsl:when test="ancestor::d:sect4">5</xsl:when>
        <xsl:when test="ancestor::d:sect3">4</xsl:when>
        <xsl:when test="ancestor::d:sect2">3</xsl:when>
        <xsl:when test="ancestor::d:sect1">2</xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:element name="h{$level+1}" namespace="http://www.w3.org/1999/xhtml">
      <xsl:attribute name="class">title</xsl:attribute>
      <xsl:call-template name="anchor">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$node"/>
        </xsl:call-template>
      </xsl:variable>

      <a href="#{$id}">
        <xsl:apply-templates select="$node" mode="object.title.markup">
          <xsl:with-param name="allow-anchors" select="1"/>
        </xsl:apply-templates>
      </a>
    </xsl:element>
  </xsl:template>

  <xsl:template name="division.title">
    <xsl:param name="node" select="."/>

    <h1>
      <xsl:attribute name="class">title</xsl:attribute>
      <xsl:call-template name="anchor">
        <xsl:with-param name="node" select="$node"/>
        <xsl:with-param name="conditional" select="0"/>
      </xsl:call-template>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$node"/>
        </xsl:call-template>
      </xsl:variable>

      <a href="#{$id}">
        <xsl:apply-templates select="$node" mode="object.title.markup">
          <xsl:with-param name="allow-anchors" select="1"/>
        </xsl:apply-templates>
      </a>
    </h1>
  </xsl:template>
</xsl:stylesheet>
