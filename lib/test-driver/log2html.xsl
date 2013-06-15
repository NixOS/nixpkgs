<?xml version="1.0"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method='html' encoding="UTF-8"
              doctype-public="-//W3C//DTD HTML 4.01//EN"
              doctype-system="http://www.w3.org/TR/html4/strict.dtd" />

  <xsl:template match="logfile">
    <html>
      <head>
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
        <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js"></script>
        <script type="text/javascript" src="treebits.js" />
        <link rel="stylesheet" href="logfile.css" type="text/css" />
        <title>Log File</title>
      </head>
      <body>
        <h1>VM build log</h1>
        <p>
          <a href="javascript:" class="logTreeExpandAll">Expand all</a> |
          <a href="javascript:" class="logTreeCollapseAll">Collapse all</a>
        </p>
        <ul class='toplevel'>
          <xsl:for-each select='line|nest'>
            <li>
              <xsl:apply-templates select='.'/>
            </li>
          </xsl:for-each>
        </ul>

        <xsl:if test=".//*[@image]">
          <h1>Screenshots</h1>
          <ul class="vmScreenshots">
            <xsl:for-each select='.//*[@image]'>
              <li><a href="{@image}"><xsl:value-of select="@image" /></a></li>
            </xsl:for-each>
          </ul>
        </xsl:if>

      </body>
    </html>
  </xsl:template>


  <xsl:template match="nest">

    <!-- The tree should be collapsed by default if all children are
         unimportant or if the header is unimportant. -->
    <xsl:variable name="collapsed" select="not(./head[@expanded]) and count(.//*[@error]) = 0"/>

    <xsl:variable name="style"><xsl:if test="$collapsed">display: none;</xsl:if></xsl:variable>

    <xsl:if test="line|nest">
      <a href="javascript:" class="logTreeToggle">
        <xsl:choose>
          <xsl:when test="$collapsed"><xsl:text>+</xsl:text></xsl:when>
          <xsl:otherwise><xsl:text>-</xsl:text></xsl:otherwise>
        </xsl:choose>
      </a>
      <xsl:text> </xsl:text>
    </xsl:if>

    <xsl:apply-templates select='head'/>

    <!-- Be careful to only generate <ul>s if there are <li>s, otherwise it’s malformed. -->
    <xsl:if test="line|nest">

      <ul class='nesting' style="{$style}">
        <xsl:for-each select='line|nest'>

          <!-- Is this the last line?  If so, mark it as such so that it
               can be rendered differently. -->
          <xsl:variable name="class"><xsl:choose><xsl:when test="position() != last()">line</xsl:when><xsl:otherwise>lastline</xsl:otherwise></xsl:choose></xsl:variable>

          <li class='{$class}'>
            <span class='lineconn' />
            <span class='linebody'>
              <xsl:apply-templates select='.'/>
            </span>
          </li>
        </xsl:for-each>
      </ul>
    </xsl:if>

  </xsl:template>


  <xsl:template match="head|line">
    <code>
      <xsl:if test="@error">
        <xsl:attribute name="class">errorLine</xsl:attribute>
      </xsl:if>
      <xsl:if test="@warning">
        <xsl:attribute name="class">warningLine</xsl:attribute>
      </xsl:if>
      <xsl:if test="@priority = 3">
        <xsl:attribute name="class">prio3</xsl:attribute>
      </xsl:if>

      <xsl:if test="@type = 'serial'">
        <xsl:attribute name="class">serial</xsl:attribute>
      </xsl:if>

      <xsl:if test="@machine">
        <xsl:choose>
          <xsl:when test="@type = 'serial'">
            <span class="machine"><xsl:value-of select="@machine"/># </span>
          </xsl:when>
          <xsl:otherwise>
            <span class="machine"><xsl:value-of select="@machine"/>: </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="@image">
          <a href="{@image}"><xsl:apply-templates/></a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </code>
  </xsl:template>


  <xsl:template match="storeref">
    <em class='storeref'>
      <span class='popup'><xsl:apply-templates/></span>
      <span class='elided'>/...</span><xsl:apply-templates select='name'/><xsl:apply-templates select='path'/>
    </em>
  </xsl:template>

</xsl:stylesheet>
