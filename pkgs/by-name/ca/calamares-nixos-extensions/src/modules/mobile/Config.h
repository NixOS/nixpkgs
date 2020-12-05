/* SPDX-FileCopyrightText: 2020 Oliver Smith <ollieparanoid@postmarketos.org>
 * SPDX-License-Identifier: GPL-3.0-or-later */
#pragma once
#include <QObject>
#include <memory>

class Config : public QObject
{
    Q_OBJECT
    /* welcome */
    Q_PROPERTY( QString osName READ osName CONSTANT FINAL )
    Q_PROPERTY( QString arch READ arch CONSTANT FINAL )
    Q_PROPERTY( QString device READ device CONSTANT FINAL )
    Q_PROPERTY( QString userInterface READ userInterface CONSTANT FINAL )
    Q_PROPERTY( QString version READ version CONSTANT FINAL )

    /* default user */
    Q_PROPERTY( QString username READ username CONSTANT FINAL )
    Q_PROPERTY( QString userPassword READ userPassword WRITE setUserPassword NOTIFY userPasswordChanged )

    /* ssh server + credentials */
    Q_PROPERTY( QString sshdUsername READ sshdUsername WRITE setSshdUsername NOTIFY sshdUsernameChanged )
    Q_PROPERTY( QString sshdPassword READ sshdPassword WRITE setSshdPassword NOTIFY sshdPasswordChanged )
    Q_PROPERTY( bool isSshEnabled READ isSshEnabled WRITE setIsSshEnabled )

    /* full disk encryption */
    Q_PROPERTY( QString fdePassword READ fdePassword WRITE setFdePassword NOTIFY fdePasswordChanged )
    Q_PROPERTY( bool isFdeEnabled READ isFdeEnabled WRITE setIsFdeEnabled )

    /* partition job */
    Q_PROPERTY( QString cmdLuksFormat READ cmdLuksFormat CONSTANT FINAL )
    Q_PROPERTY( QString cmdLuksOpen READ cmdLuksOpen CONSTANT FINAL )
    Q_PROPERTY( QString cmdMkfsRoot READ cmdMkfsRoot CONSTANT FINAL )
    Q_PROPERTY( QString cmdMount READ cmdMount CONSTANT FINAL )
    Q_PROPERTY( QString targetDeviceRoot READ targetDeviceRoot CONSTANT FINAL )

    /* users job */
    Q_PROPERTY( QString cmdSshdEnable READ cmdSshdEnable CONSTANT FINAL )
    Q_PROPERTY( QString cmdSshdDisable READ cmdSshdDisable CONSTANT FINAL )

public:
    Config( QObject* parent = nullptr );
    void setConfigurationMap( const QVariantMap& );

    /* welcome */
    QString osName() const { return m_osName; }
    QString arch() const { return m_arch; }
    QString device() const { return m_device; }
    QString userInterface() const { return m_userInterface; }
    QString version() const { return m_version; }

    /* default user */
    QString username() const { return m_username; }
    QString userPassword() const { return m_userPassword; }
    void setUserPassword( const QString& userPassword );

    /* ssh server + credetials */
    QString sshdUsername() const { return m_sshdUsername; }
    QString sshdPassword() const { return m_sshdPassword; }
    bool isSshEnabled() { return m_isSshEnabled; }
    void setSshdUsername( const QString& sshdUsername );
    void setSshdPassword( const QString& sshdPassword );
    void setIsSshEnabled( bool isSshEnabled );

    /* full disk encryption */
    QString fdePassword() const { return m_fdePassword; }
    bool isFdeEnabled() { return m_isFdeEnabled; }
    void setFdePassword( const QString& fdePassword );
    void setIsFdeEnabled( bool isFdeEnabled );

    /* partition job */
    QString cmdLuksFormat() const { return m_cmdLuksFormat; }
    QString cmdLuksOpen() const { return m_cmdLuksOpen; }
    QString cmdMkfsRoot() const { return m_cmdMkfsRoot; }
    QString cmdMount() const { return m_cmdMount; }
    QString targetDeviceRoot() const { return m_targetDeviceRoot; }

    /* users job */
    QString cmdPasswd() const { return m_cmdPasswd; }
    QString cmdSshdEnable() const { return m_cmdSshdEnable; }
    QString cmdSshdDisable() const { return m_cmdSshdDisable; }
    QString cmdSshdUseradd() const { return m_cmdSshdUseradd; }

private:
    /* welcome */
    QString m_osName;
    QString m_arch;
    QString m_device;
    QString m_userInterface;
    QString m_version;

    /* default user */
    QString m_username;
    QString m_userPassword;

    /* ssh server + credetials */
    QString m_sshdUsername;
    QString m_sshdPassword;
    bool m_isSshEnabled;

    /* full disk encryption */
    QString m_fdePassword = "";
    bool m_isFdeEnabled = false;

    /* partition job */
    QString m_cmdLuksFormat;
    QString m_cmdLuksOpen;
    QString m_cmdMkfsRoot;
    QString m_cmdMount;
    QString m_targetDeviceRoot;

    /* users job */
    QString m_cmdPasswd;
    QString m_cmdSshdEnable;
    QString m_cmdSshdDisable;
    QString m_cmdSshdUseradd;

signals:
    /* default user */
    void userPasswordChanged( QString userPassword );

    /* ssh server + credetials */
    void sshdUsernameChanged( QString sshdUsername );
    void sshdPasswordChanged( QString sshdPassword );
    /* isSshEnabled doesn't need a signal, we don't read it from QML */

    /* full disk encryption */
    void fdePasswordChanged( QString fdePassword );
};
